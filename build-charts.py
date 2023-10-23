#!/usr/bin/python

import os
import sys
import shutil
import math
import subprocess

SRCDIR = os.path.dirname(os.path.abspath(sys.argv[0]))
DIR = sys.argv[1]
CHARTDIR = os.path.abspath(DIR)

filesystems = []
scales = []
clients = []
modes = ['rw', 'ro']


def build_chart(chart_format, chart_type, file_subname, filesystems, clients, scales, modes):

	file_name = chart_type

	if file_subname:
		file_name = file_name + '-' + file_subname

	f = open(SRCDIR + '/' + chart_format + '/multi-' + chart_type + '.plot', 'r')
	template = f.read()

	template = template.replace('TITLE', chart_type)
	template = template.replace('FILE', file_name)
	template = template.replace('FSCOUNT', str(len(filesystems)))

	if chart_format == 'png':
		template = template.replace('WIDTH', str(5 * len(filesystems)))
	else:
		template = template.replace('WIDTH', str(600 * len(filesystems)))

	f = open(SRCDIR + '/snippets/multi-' + chart_type + '.plot', 'r')
	snippet = f.read()

	plotfile = CHARTDIR + '/' + chart_format + '-' + file_name + '.plot'
	f = open(plotfile, 'w')

	print('generating %s' % (plotfile,))

	for c in clients:	# there's one client count
		for s in scales:
			for m in modes:

				max_tps = 0.0

				min_latency = 1000000000.0
				max_latency = 0.0

				for fs in filesystems:

					if not os.path.isdir('%s/%s/%s/%s' % (fs, s, m, c)):
						continue

					with open('%s/%s/%s/%s/tps.data' % (fs, s, m, c), 'r') as x:
						for line in x.readlines():
							tps = float(line.split(' ')[2])
							max_tps = max(max_tps, tps)

					with open('%s/%s/%s/%s/summary.data' % (fs, s, m, c), 'r') as x:
						for line in x.readlines():
							min_latency = min(min_latency, float(line.split(' ')[3]))
							max_latency = max(max_latency, float(line.split(' ')[7]))

				if chart_type.startswith('tps'):
					if max_tps != 0.0:
						template += 'set yrange [0:%d]' % (int(max_tps),)
						template += '\n'
				else:
					if max_latency != 0.0:

						min_latency = 10 ** math.floor(math.log(min_latency) / math.log(10.0))
						max_latency = 10 ** math.ceil(math.log(max_latency) / math.log(10.0))

						template += 'set yrange [%d:%d]' % (int(min_latency), int(max_latency))
						template += '\n'

				for fs in filesystems:

					if not os.path.isdir('%s/%s/%s/%s' % (fs, s, m, c)):
						continue

					tmp = snippet.replace('FS', fs)
					tmp = tmp.replace('TYPE', m)
					tmp = tmp.replace('SCALE', str(s))
					tmp = tmp.replace('CLIENTS', c)

					template += tmp + '\n'

				template += '\n'

	f.write(template)

	r = subprocess.Popen(['/usr/bin/gnuplot', plotfile], cwd=CHARTDIR)


if __name__ == '__main__':

	os.chdir(DIR)

	filesystems = [ f.name for f in os.scandir('.') if f.is_dir() ]
	filesystems = sorted(filesystems)

	for fs in filesystems:

		tmp = [ int(f.name) for f in os.scandir('%s' % (fs,)) if f.is_dir() ]
		scales.extend(tmp)

		for s in tmp:

			for m in modes:

				if not os.path.isdir('%s/%d/%s' % (fs,s,m)):
					continue

				tmp = [ f.name for f in os.scandir('%s/%d/%s' % (fs,s,m)) if f.is_dir() ]
				clients.extend(tmp)

	clients = sorted(set(clients))
	scales = sorted(set(scales))

	for chart_type in [ 'latencies-short', 'latencies', 'tps-short', 'tps' ]:

		build_chart('png', chart_type, None, filesystems, clients, scales, modes)
		build_chart('svg', chart_type, None, filesystems, clients, scales, modes)

		for fs in filesystems:
			build_chart('png', chart_type, fs, [fs], clients, scales, modes)
			build_chart('svg', chart_type, fs, [fs], clients, scales, modes)

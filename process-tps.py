#!/usr/bin/python

import sys

data_ts = []
data_delta = []
data_tps = []

ts_prev = None
ts_first = None
xact_prev = None

for line in sys.stdin:

	line = line.strip().split('|')

	if len(line) < 7:
		continue

	ts = line[0]
	if ts == 'epoch':
		continue

	ts = float(line[0])
	xact = float(line[5])

	if ts_prev is not None:

		ts_relative = (ts - ts_first)
		ts_delta = (ts - ts_prev)

		tps = int((xact - xact_prev) / (ts - ts_prev))

		data_ts.append(ts_relative)
		data_delta.append(ts_delta)
		data_tps.append(tps)

	ts_prev = ts
	xact_prev = xact

	if ts_first is None:
		ts_first = ts


for i in range(0, len(data_tps)):

	idx_from = max(i - 5, 0)
	idx_to = min(i + 5, len(data_tps))

	tmp = data_tps[idx_from:idx_to]

	print('%f %f %d %d' % (data_ts[i], data_delta[i], data_tps[i], sum(tmp) / len(tmp)))

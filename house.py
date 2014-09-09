import os
import json
from flask import Flask
from flask import request
from flask import render_template
import time
from datetime import date
import natural.date

import redis
app = Flask(__name__)
app.debug = True

redis_url = os.getenv('REDISTOGO_URL', 'redis://localhost:6379')
redis = redis.from_url(redis_url)

@app.route("/")
def hello():
	selbots = [];
	for key in sorted(redis.keys()):
		if ('host:Dev' in key and redis.get(key)):
			s = json.loads(redis.get(key))
			# time in seconds since epoch as int
			now = int(time.time())
			mins = (now - s['time']) / 60;
			rel = natural.date.delta(now, s['time'], words=False)
			s['server'] = key
			s['minutes_ago'] = mins
			s['time_ago_relative'] = rel[0]
			selbots.append(s)

	return render_template('house.html', servers=selbots)

@app.route("/heartbeat/<hostname>", methods=['GET'])
def heartbeat( hostname ):
	running = request.args.get('running')
	branch = request.args.get('branch')
	# 'time': time in seconds since epoch as int
	redis.set('host:' + hostname, json.dumps({ 'running': running, 'branch': branch, 'time':  int(time.time()) }))
	return "Heartbeat!"

if __name__ == "__main__":
    port = int(os.environ.get("PORT", 5000))
    app.run(host='0.0.0.0', port=port)

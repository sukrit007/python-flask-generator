import flask
import sys
import python-demo

app = flask.Flask(__name__)


@app.route('/')
def root():
    return flask.jsonify({
        'name': 'python-demo api',
        'version': python-demo.__version__,
        'python': sys.version
    })

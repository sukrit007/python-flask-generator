import flask
import sys
import myapp

app = flask.Flask(__name__)


@app.route('/')
def root():
    return flask.jsonify({
        'name': 'myapp api',
        'version': myapp.__version__,
        'python': sys.version
    })

"""Core application"""
from quart import Quart

app = Quart(__name__)


@app.route('/')
async def hello():
    """Return static file"""
    return 'hello'

"""Core integration"""

from .app import app


def run():
    """Start the server"""
    app.run()

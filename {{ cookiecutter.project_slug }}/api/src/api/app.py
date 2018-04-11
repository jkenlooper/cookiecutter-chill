import os
import sys

from flask import Flask

class API(Flask):
    "API App"

def make_app(config=None, **kw):
    app = API('api')


    if config:
        config_file = config if config[0] == os.sep else os.path.join(os.getcwd(), config)
        app.config.from_pyfile(config_file)

    app.config.update(kw)

    # Import the views
    from llama import LlamaView

    # Register the views
    app.add_url_rule('/llama/', view_func=LlamaView.as_view('llama'))

    return app

def main():
    from gevent import pywsgi
    config_file = sys.argv[1]
    app = make_app(config=config_file)
    app.debug = app.config.get('DEBUG')

    if app.debug:
        app.run(
                host='0.0.0.0',
                port=5858,
                use_reloader=True,
                )
    else:
        server = pywsgi.WSGIServer(('0.0.0.0', 5858), app)
        server.serve_forever(stop_timeout=10)

if __name__ == "__main__":
    main()

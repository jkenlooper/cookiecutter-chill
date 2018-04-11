from flask import json, request, abort
from flask.views import MethodView

encoder = json.JSONEncoder(indent=2, sort_keys=True)

class LlamaView(MethodView):
    """
    Handle llama queries
    """
    def post(self):
        args = {}
        xhr_data = request.get_json()
        if xhr_data:
            args.update(xhr_data)
        args.update(request.form.to_dict(flat=True))
        args.update(request.args.to_dict(flat=True))

        if len(args.keys()) == 0:
            abort(400)

        # TODO: Process args for llamaness
        processed = {
            "llama-check": True
            }

        return encoder.encode(processed)

import os
c.NotebookApp.extra_static_paths = ['{}/js/'.format(os.environ['ROOTSYS']), '/usr/local/lib/python3.8/dist-packages/notebook/static/components/requirejs']

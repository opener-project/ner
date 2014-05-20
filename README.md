# NER

This repository contains the source code for the primary NER component of the
OpeNER project. This component provides a CLI interface for the various kernels
as well as providing a Sinatra based web service.

### Confused by some terminology?

This software is part of a larger collection of natural language processing
tools known as "the OpeNER project". You can find more information about the
project at (the OpeNER portal)[http://opener-project.github.io]. There you can
also find references to terms like KAF (an XML standard to represent linguistic
annotations in texts), component, cores, scenario's and pipelines.

Quick Use Example
-----------------

Installing the ner can be done by executing:

    gem install opener-ner

Please bare in mind that all components in OpeNER take KAF as an input and
output KAF by default.

### Command line interface

You should now be able to call the NER as a regular shell
command: by its name. Once installed the gem normalyl sits in your path so you can call it directly from anywhere.

This aplication reads a text from standard input in order to identify the language.

    cat some_kind_of_kaf_file.kaf | ner


This will output a kaf file containing the named entities. An excerpt can be
seen here

```
<entity eid="e3" type="organization">
  <references>
    <!--North Yorkshire Police-->
    <span>
      <target id="t17" />
      <target id="t18" />
      <target id="t19" />
    </span>
  </references>
</entity>
```

### Webservices

You can launch a language identification webservice by executing:

    ner-server

This will launch a mini webserver with the webservice. It defaults to port 9292,
so you can access it at <http://localhost:9292>.

To launch it on a different port provide the `-p [port-number]` option like
this:

    ner-server -p 1234

It then launches at <http://localhost:1234>

Documentation on the Webservice is provided by surfing to the urls provided
above. For more information on how to launch a webservice run the command with
the ```-h``` option.


### Daemon

Last but not least the NER comes shipped with a daemon that
can read jobs (and write) jobs to and from Amazon SQS queues. For more
information type:

    ner-daemon -h


Description of dependencies
---------------------------

This component runs best if you run it in an environment suited for OpeNER
components. You can find an installation guide and helper tools in the (OpeNER
installer)[https://github.com/opener-project/opener-installer] and (an
installation guide on the Opener
Website)[http://opener-project.github.io/getting-started/how-to/local-installation.html]

At least you need the following system setup:

### Depenencies for normal use:

* MRI 1.9.3 / Jruby
* Java 1.7 or newer (There are problems with encoding in older versions).

### Dependencies if you want to modify the component:

* Maven (for building the Gem)

Domain Adaption
---------------

  TODO

Language Extension
------------------

  TODO

The Core
--------

The component is a fat wrapper around the actual language technology core. You
can find the core technolies in the following repositories:

* (ner-base)[https://github.com/opener-project/ner-base]


Where to go from here
---------------------

* Check (the project websitere)[http://opener-project.github.io]
* (Checkout the webservice)[http://opener.olery.com/ner]

Report problem/Get help
-----------------------

If you encounter problems, please email support@opener-project.eu or leave an
issue in the (issue tracker)[https://github.com/opener-project/ner/issues].


Contributing
------------

1. Fork it ( http://github.com/opener-project/ner/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request


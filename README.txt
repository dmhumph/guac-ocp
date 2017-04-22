Matt Bagnara
mbagnara@redhat.com


Based off http://guacamole.incubator.apache.org/doc/gug/guacamole-docker.html

This set of directories serves as a Guacamole OpenShift project. The purpose of containerized Guacamole is to provide a web client for VNC-style connections. Paried along with openshift-kiosk, this can provide a containerized virtual development desktop environment! WOW!

USAGE
the provided Makefile allows you to build each container using barebones docker. 

To deploy into openshift: first create a project and name it. Next, modify all the buildConfig and deploymentConfig templates to reference your project on the namespace: line. Last, deploy the templates with the oc create -f template.yaml command.

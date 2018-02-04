# freeling

FROM debian:jessie

MAINTAINER Hernán 'herchu' Foffani <hfoffani@gmail.com>

include(dependencies.docker)
include(locale.docker)

ifdef(py-dv, include(python.docker))

include(freeling.docker)

ifdef(py-dv, include(pyfreeling.docker))

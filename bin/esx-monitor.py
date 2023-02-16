#!/usr/bin/python
 
import sys
import pywbem
 
wbemclient = pywbem.WBEMConnection('https://murcielago.ioturbine.com:5989',
    ('root', 'password'), 'root/cimv2')
for instance in wbemclient.EnumerateInstances('CIM_NumericSensor'):
    print "%s %s %s" % (instance, instance, instance)

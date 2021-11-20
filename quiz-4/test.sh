#!/bin/bash


javac Quiz_4.java
java -classpath ".:sqlite-jdbc-3.32.3.2.jar" Quiz_4

python3 Quiz_4.py

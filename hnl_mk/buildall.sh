#!/bin/sh
for builder in $(ls /build/build-*sh)
do
		$builder
done

							 

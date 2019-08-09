#!/bin/bash
echo "Starting DC East (dc-east)"
pushd ./dc_east/
vagrant up &
process_id_east=$!
echo "Starting DC West (dc-west)"
popd
pushd ./dc_west/
vagrant up &
process_id_west=$!
echo "Waiting ..."
wait $process_id_east && wait $process_id_west
popd
echo "Both DCs started !"

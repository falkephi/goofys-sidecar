#!/bin/bash


mkdir -p $MOUNTPOINT

[[ -z "${S3UID}" ]] || GOOFYS_OPTS="$GOOFYS_OPTS --uid ${S3UID}"
[[ -z "${S3GID}" ]] || GOOFYS_OPTS="$GOOFYS_OPTS --gid ${S3GID}"
[[ -z "${REGION}" ]] || GOOFYS_OPTS="$GOOFYS_OPTS --region ${REGION}"
[[ -z "${DIR_MODE}" ]] || GOOFYS_OPTS="$GOOFYS_OPTS --dir-mode ${DIR_MODE}"

[[ -z "${ALLOWEMPTY}" ]] || FUSE_OPTS="$FUSE_OPTS -o nonempty"
[[ -z "${ALLOW_OTHER}" ]] || FUSE_OPTS="$FUSE_OPTS -o allow_other"
[[ -z "${S3URL}" ]] || FUSE_OPTS="$FUSE_OPTS -o url=${S3URL}"

echo "Running: goofys $GOOFYS_OPTS $FUSE_OPTS  $BUCKET $MOUNTPOINT ..."
exec /goofys $GOOFYS_OPTS $FUSE_OPTS -f $BUCKET $MOUNTPOINT 


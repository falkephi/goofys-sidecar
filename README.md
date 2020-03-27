Sidecar container to mount an s3 bucket and share it with another container in
the same pod.

This code is heavily based on the s3fs-sidecar by signaleleven: https://github.com/signaleleven/s3fs-sidecar


Create secret with:

`kubectl create secret generic awssecret --from-literal=AWS_ACCESS_KEY_ID='MYACCESSKEYIDXXXXX' --from-literal=AWS_SECRET_ACCESS_KEY='mySecretKeyDontTellAnyone`


Example pod config:

```
---
apiVersion: v1
kind: ConfigMap
metadata:
  name: mountconfig
data:
  BUCKET: 'mybucketname'
  MOUNTPOINT: '/test'

---
apiVersion: v1
kind: Pod
metadata:
  name: two-containers
spec:

  restartPolicy: Never

  volumes:
  - name: shared-data
    emptyDir: {}

  containers:

  - name: s3sidecar
    image: meierphi/goofys-sidecar
    imagePullPolicy: Always
    securityContext:
      privileged: true
      capabilities:
        add:
          - SYS_ADMIN
    env:
      - name: AWS_ACCESS_KEY_ID
        valueFrom:
          secretKeyRef:
            name: awssecret
            key: AWS_ACCESS_KEY_ID
      - name: AWS_SECRET_ACCESS_KEY
        valueFrom:
          secretKeyRef:
            name: awssecret
            key: AWS_SECRET_ACCESS_KEY
      - name: BUCKET
        valueFrom:
         configMapKeyRef:
          name: mountconfig
          key: BUCKET
      - name: MOUNTPOINT
        valueFrom:
         configMapKeyRef:
           name: mountconfig
           key: MOUNTPOINT

    volumeMounts:
    - name: shared-data
      mountPath: /test
      mountPropagation: Bidirectional

  - name: debian-container
    image: debian
    volumeMounts:
    - name: shared-data
      mountPath: /pod-data
      mountPropagation: HostToContainer

    command: ["/bin/sh"]
    args: ["-c", "echo running... && trap : TERM INT; (while true; do sleep 10; done) & wait"]

```

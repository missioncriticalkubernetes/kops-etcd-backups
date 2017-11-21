# Introduction

> Create and expire EBS-snapshots of kops created etcd-volumes.

# What is this?

This application will take a snapshot of your etcd EBS' every hour. Afterwards it expires the snapshots with reasonable retention.

We make backups of the etcd block-device, not the etcd data-directory. This means that we can *only* restore etcd in its entirety and not partially.

# Installation

### AWS Credentials

Create an AWS-user with the following permissions:
```
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "Stmt1510827282000",
            "Effect": "Allow",
            "Action": [
                "ec2:DescribeInstances",
                "ec2:CreateSnapshot",
                "ec2:DeleteSnapshot",
                "ec2:DescribeSnapshots",
                "ec2:DescribeVolumes",
                "ec2:DescribeTags",
                "ec2:CreateTags"
            ],
            "Resource": [
                "*"
            ]
        }
    ]
}
```

Create a kubernetes secret to hold the credentials:
```
kubectl -n kube-system create secret generic kops-etcd-backups --from-literal=AWS_ACCESS_KEY_ID=some-access-key-id --from-literal=AWS_SECRET_ACCESS_KEY=some-secret-access-key
```

### Install manifests

```
kubectl apply -f https://raw.githubusercontent.com/missioncriticalkubernetes/kops-etcd-backups/master/kubernetes/install-latest.yaml
```

### Configure retention policy

To expire snapshots we use [alestic/ec2-expire-snapshots](https://github.com/alestic/ec2-expire-snapshots).

Edit the Kubernetes DaemonSet and set the `SNAPSHOT_RETENTION` environment-variable in the container. The default value is `--keep-most-recent=1 --keep-first-hourly=24 --keep-first-daily=7`.

# Restore etcd from snapshots

**THIS WILL CAUSE DOWNTIME**

* Select the snapshots to restore
* Set the desired and minimum replicas of the master ASGs to 0
* Delete the existing volumes
* Create volumes from the snapshots and copy the tags over
  * Make sure you create the volumes in the right availability-zone
* Set the desired and minimum replicas of the master ASGs to 1

### Caveats

When you create new volumes from your snapshots the previously created snapshots will no longer be expired automatically. Delete these manually.

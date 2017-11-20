# Introduction

> Create and expire EBS-snapshots of kops created etcd-volumes.

# What is this?

This application will take a snapshot of your etcd EBS' every hour. Afterwards it expires the snapshots with reasonable retention.

# Installation

##### AWS Credentials

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

##### Install manifests

```
kubectl apply -f https://raw.githubusercontent.com/missioncriticalkubernetes/kops-etcd-backups/master/kubernetes/install-latest.yaml
```

This week in aws, I used and learned something new about the following services:

1.) AWS VPC - I've known for a while that you can add an additional CIDR Block to a VPC. This is useful if you run out of private IPs in your current CIDR and need more private IPs, but you can't reprovision all of your resources and your VPC. Once of the challenges I run into in large enteprises is that the private IP range is often tightly controlled, and getting address blocks issued is like tryin to move a mountain. When you start working with Kubernetes (either self-managed or EKS, or even using ECS and Fargate), you can really burn through IPs. In the secure container platform architectures  I've worked with (OpenShift, Kubernetes, ECS/Fargate), ingress gets routed through a reverse proxy to applications and egress routes through a node providing NAT. The underlying compute nodes only care about communicating with the master node and other members of the cluster. Direct incoming traffic from the Enterprise network is blocked, an outgoing traffic is served by the clusters NAT, so while the compute node (EC2 instance in this case) needs a private IP, it does not have to be an Enteprise-issued private IP. In otherwords, I don't have to burn through my precious pool of Enterprise-managed IPs when I'm spinning up containers. Of course, there are Enterprise management and monitoring requirements that should be considered, but those should really be kept outside of the cluster.

2.) Stumping AWS Support on EMR and Presto Support for Databases of the Same Family - AWS EMR configuration.json provides a relatively easy mechanism for adding data sources to Presto (https://docs.aws.amazon.com/emr/latest/ReleaseGuide/presto-adding-db-connectors.html). AwS also supports a large number of connectors, including Postres, MySQL, Hadoop, and more (https://docs.aws.amazon.com/emr/latest/ReleaseGuide/emr-release-5x.html#emr-5320-class). Unfortinately, the AWS EMR only support ONE of each database classification, so after two days of back and forth, AWS Support confirmed the only "official" option adding a second Postgres database was to write a custom bootstrap script to provision a second Postgres database. This is a perfectly reasonable solution, and I had already added it to the next sprint plan, but my team needed to test changes to the database IAM model before the end of the current sprint. Fortunately, AWS did provide a "blackhole" presto connector, which is intended as a test harness, but by passing the following classification to the EMR configuration (via a template in my Terraform config for the EMR cluster), I was able to trick EMR into enabling access to the second database:

  {
    "classification": "presto-connector-blackhole",
    "properties": {
        "connector.name": "postgresql",
        "connection-url": "${conn3_url}",
        "connection-user": "${conn3_user}",
        "connection-password": "${conn3_password}"
    },
    "configurations": []
  }

  3.) Secure(ish) Container Supply Chain - You really can't assume containers pulled from DockerHub are safe: often they are using out-of-date base images, or in some cases, contain malware. If you don't have the fortitiude to integrate Quay or Aqua into your build pipelines, AWS ECR (with it's built-in Clair scanning) is an easy win to establish an MVP secure container registry. 
Back in the dark ages (about 1997) when I had learned just enough about the Internet to get paid, in order to get enough bandwidth to serve traffic, route requests, transfer files, etc., you'd add multiple NICs to a server (or sometimes a "high-end" graphics workstation) and configure them as "network bonded" adapters. Personally, I didn't do much work with systems configured in a network bonded mode: even back in the late 1990's and early 2000's, we'd discovered scaling horizontally provided better perfomance and better reduncancy at a lower cost since we could split the load between two less powerful servers, which together usually cost half of a single server with double the capacity.

That being said, we did user multi-homing (an alrenative configuration to network bonding where the system exists on seperate networks) to support redundant ingress, egress, and load-balanced reverse proxying.

Today, with VPC peering, VPC endpoints, network optimized instance types, and Elastic Load Balancers, and the ease of deploying HA/FT network architectures in the cloud, I haven't seen a real use for olds-chool network bonding. Even in the big data platforms I work on that process petabytes of data, there really isn't an application for network bonding. Of course, I leverage cloud native services whenever possible, so it's reasonable to think AWS and Azure are leveraging network bonding at the cloud infrastructure layer. Fortunately, I trust AWS enough (and pay them accordingly) so I don't wory need about how the sausage is made in order to make a magnificently delicious sausage pizza.
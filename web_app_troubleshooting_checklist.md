#Web Application Troubleshooting Checklist

##Issue: User reports "the Web Application is Down"

###1.) AVOID THE PROBLEM IN THE FIRST PLACE - The root cause of a web application going down is fundamentally a failure to implement highly-available, fault tolerant architecture. So, from the start, design the application to at minimum adhere to the following:

    - Application components are loosely coupled AND can easily switch between the next-in-line redundant services (load balancing reverse proxies can really help here)
    - Applications are themselves stateless and don't store any persistent data where compute happens. If they fail, no it's no big deal.
    - Distribute redundant application components geographically to minimize latency and mitigate region-wide issues
    - For stateful date, ensure it is stored locally with on a resilient file system (i.e. RAID,HDFS,etc.) and distributed regionally, or both (i.e. S3,EFS,RDS Multi-AZ)
    - At minimum, leverage DNS failover
    - Instrument health checks for all endpoints and monitor
    - As a bonuse, automate all the infrastruture using infrastructure as code so it can be quickly redeployed from scratch and persistent data restored from backups.

Detecting, investingating, and recovering from failure in a well architected web application should be straight-forward if these principles are followed.

###2.) Otherwise, if you web application is stuck in 1997, first request the user to provide with the error message they are seeing (screenshots are best, but even whether it's a 4xx error, 5xx error, or no error tells a lot).

###3.) Try to replicate the error from your workstation (and get a friend in another location to try as well). This can help narrow down if it is an issue specific to the user's network (or even workstation), or if it is a problem impacting all users. With this step, you can eliminate or identify an issue with enterprise firewalls, ISPs, root DNS, or anything else between the user and your web application.

###4.) If the error log is actually from an application service router or application itself: typically 500 range if it is at the webserver, reverse proxy, or load balancer layer; while applications may have more detailed "stack traces". These error codes or application stack traces point you to which log files you should investigate.

###5.) Hopefully you learn from the logs that the apache web server just had a hiccup after the latest yum updates and you just need to do a "systemctl restart httpd24-httpd". 

###6.) Otherise, it may take some digging, restarting and stopping services, checking expired TLS certificates, expired software licenses, check to see if someone stopped firewalld when deploying the app because they were too lazy to actually add the correct ingress rules, but since the system restarted after the latest yum updates, firewalld restarted, causing the application to fail... You get the idea, all of which could have been avoided if you'd spent 1/100th the time you're going to spend chasing hundreds of issues like this over the next five years rather than implementing STEP 1.
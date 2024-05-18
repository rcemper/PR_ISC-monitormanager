# Monitor Manager    
This example is described in details in my [Article in DC](https://community.intersystems.com/post/enhanced-monitor-manager)   

## Docker   

### Prerequisites
Make sure you have [git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git) and [Docker desktop](https://www.docker.com/products/docker-desktop) installed.
### Installation
Clone/git pull the repo into any local directory
```
$ git clone https://github.com/rcemper/PR_ISC-monitormanager.git
```
```
$ docker compose up -d && docker compose logs -f
```
The container has a demo production that you need to start        
http://localhost:42773/csp/user/EnsPortal.ProductionConfig.zen?PRODUCTION=JK.MONMGR.Production

To trigger some events you may try from Terminal   
``` 
ZN "%SYS"
DO ^JOURNAL
```  
Stop and Start creates events that you can see in Monitor.    
    
The example takes every event.  
It's up to you to apply filters on what you really are intersted in.  

To open IRIS Terminal do:
```
$ docker-compose exec iris iris session iris 
USER>
```
or using **WebTerminal**     
http://localhost:42773/terminal/      

To access IRIS System Management Portal   
http://localhost:42773/csp/sys/UtilHome.csp    


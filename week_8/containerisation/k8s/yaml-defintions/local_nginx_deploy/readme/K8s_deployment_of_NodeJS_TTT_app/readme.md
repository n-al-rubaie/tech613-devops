# K8s deployment of NodeJS TTT app

![alt text](architecture-diagram-updated.png)

## How the Deployment Works

1. **User:** Opens the Tic-Tac-Toe application through `localhost:30001`.
2. **NodePort Service:** `ttt-app-service` receives external traffic on port `30001` and forwards it to port `3000`.
3. **Application Deployment:** Kubernetes distributes requests between the three Node.js application pods.
4. **MongoDB Service:** Each application pod connects to MongoDB using `mongo-service:27017`.
5. **MongoDB Pod:** Receives database requests and accesses the `tictactoe` database.


 ## Confirmed Application Configuration

| Setting | Value |
|----------|----------|
| Docker image | `nalrubaie/tech613-tttapp:1.2.0` |
| Application | Node.js |
| Container port | `3000` |
| Database environment variable | `MONGODB_URI` |
| Database port | `27017` |
| Database name | `tictactoe` |   


# Update ttt-app-deploy.yml in local-ttt-app-deploy folder with:

```
# Kubernetes Deployment API version
apiVersion: apps/v1

# Resource type
kind: Deployment

metadata:
  # Name of the Deployment
  name: ttt-app-deployment

spec:
  # Run 3 replicas (pods) of the application
  replicas: 3

  # Select pods with the label app: ttt-app
  selector:
    matchLabels:
      app: ttt-app

  # Pod template definition
  template:
    metadata:
      labels:
        # Label assigned to created pods
        app: ttt-app

    spec:
      containers:
        # Container configuration
        - name: ttt-app

          # Docker image to deploy
          image: nalrubaie/tech613-tttapp:1.2.0

          ports:
            # Expose container port 3000
            - containerPort: 3000
```

# Update ttt-app-service.yml in local-ttt-app-deploy folder with:

```
# Kubernetes API version
apiVersion: v1

# Resource type
kind: Service

metadata:
  # Name of the Service
  name: ttt-app-service

spec:
  # Expose the service on a port of each cluster node
  type: NodePort

  # Route traffic to pods with this label
  selector:
    app: ttt-app

  ports:
    # Service port configuration
    - port: 3000

      # Port on the container/pod
      targetPort: 3000

      # External port on the Kubernetes node
      nodePort: 30001
```

## Deploy the app 

`kubectl apply -f local-ttt-app-deploy/`

This tells Kubernetes to create the Deployment and Service using your YAML files.

![alt text](image-1.png)

## View deployments, pods and services

Run these commands one at a time:

`kubectl get deployments`


`kubectl get pods`


`kubectl get services`

The first Kubernetes deployment is running successfully.
3/3 pods running
Your results confirm:
- Deployment: 3/3 replicas ready.
- Pods: all three are Running, with zero restarts.
- Service: NodePort, forwarding port 30001 to application port 3000.

![alt text](image-2.png)

## Open the application

`http://localhost:30001/`


![alt text](image-4.png)

## deploy MongoDB

Copy `ttt-app-deploy.yml` and  `ttt-app-service.yml` from `local-ttt-app-deploy` directory to `local-ttt-app-mongo-deploy`

In the  `local-ttt-app-mongo-deploy` directory, create a new file called: `mongo-deploy.yml` and add the following code in it:

```
# Kubernetes Deployment API version
apiVersion: apps/v1

# Resource type
kind: Deployment

metadata:
  # Name of the MongoDB deployment
  name: mongo-deployment

spec:
  # Run one MongoDB pod
  replicas: 1

  # Match pods with the label app: mongo
  selector:
    matchLabels:
      app: mongo

  # Pod template configuration
  template:
    metadata:
      labels:
        # Label assigned to the MongoDB pod
        app: mongo

    spec:
      containers:
        # MongoDB container configuration
        - name: mongo

          # Official MongoDB Docker image
          image: mongo:7.0

          ports:
            # MongoDB listens on port 27017
            - containerPort: 27017
```

## Create mongodb service 

In the  `local-ttt-app-mongo-deploy` directory, create a new file called: `mongo-service.yml` and add the following code in it:

```
# Kubernetes API version
apiVersion: v1

# Resource type
kind: Service

metadata:
  # Name of the MongoDB service
  name: mongo-service

spec:
  # Internal service accessible within the cluster
  type: ClusterIP

  # Route traffic to the MongoDB pod
  selector:
    app: mongo

  ports:
    # Service port configuration
    - port: 27017

      # Port on the MongoDB container
      targetPort: 27017
```

An internal Kubernetes address shall be provided:

`mongo-service:27017`

The application pods will use this address to communicate with MongoDB.

## Update the application Deployment to connect to MongoDB

Add code below to: `ttt-app-deploy.yml` in the `local-ttt-app-mongo-deploy` folder. 


```
# Kubernetes Deployment API version
apiVersion: apps/v1

# Resource type
kind: Deployment

# Deployment metadata
metadata:
  # Name of the deployment
  name: ttt-app-deployment

# Deployment specification
spec:
  # Number of application pod replicas to run
  replicas: 3

  # Selector used to identify pods managed by this deployment
  selector:
    matchLabels:
      app: ttt-app

  # Template used to create new pods
  template:
    metadata:
      # Labels assigned to the pods
      labels:
        app: ttt-app

    spec:
      # List of containers running inside the pod
      containers:
        # Application container configuration
        - name: ttt-app

          # Docker image to deploy
          image: nalrubaie/tech613-tttapp:1.2.0

          # Container port exposed by the application
          ports:
            - containerPort: 3000

          # MongoDB connection configuration
          env:
            # Environment variable for the MongoDB connection string
            - name: MONGODB_URI

              # MongoDB service address and database name
              value: "mongodb://mongo-service:27017/tictactoe"
```

## Deploy all four Kubernetes resources

Run in bash in the `local-ttt-app-mongo-deploy` folder:

`kubectl apply -f`



![alt text](image-5.png)

Kubernetes reads all four YAML files in the folder and creates or updates:

1. `ttt-app-deployment` - Runs three replicas of the Node.js application
2. `ttt-app-service` - Exposes the application through NodePort `30001`
3. `mongo-deployment` - Runs one MongoDB replica
4. `mongo-service` - Provides internal access to MongoDB on port `27017`

### What does `-f .` mean?

- `-f` tells Kubernetes to use YAML configuration files
- `.` means the current directory
- Kubernetes will apply all YAML files in the current folder

This will deploy:

- 3 Node.js application replicas
- 1 MongoDB replica
- 1 NodePort Service
- 1 ClusterIP Service

## Check the deployments

`kubectl get deployments`

![alt text](image-6.png)

## Check the pods

`kubectl get pods`

![alt text](image-7.png)

## Check the services

`kubectl get services`

![alt text](image-8.png)


## Display a summary of the main Kubernetes resources in the current namespace

`kubectl get all`


### What does it display?

| Resource | What it shows |
|----------|---------------|
| Pods | Running application containers |
| Services | Network access to your applications |
| Deployments | Desired and available replicas |
| ReplicaSets | Manage the number of pod replicas |

![alt text](image-11.png)


## Test the ttt app (global version connected with MongoDB)

Run in url:

`http://localhost:30001/`

![alt text](image-9.png)

## Verify the MongoDB connection

`kubectl logs deployment/ttt-app-deployment`



![alt text](image-10.png)

## Results: MongoDB Connection

The most important log entry is:

```json
{
  "code": "MDB_001",
  "message": "Mongo connection established",
  "mode": "Persistent with Mongo DB",
  "mongoTarget": "mongo-service:27017/tictactoe"
}
```

This confirms:

1. **MongoDB connection established:** The application successfully connected to the database.
2. **Persistent with Mongo DB:** The application is operating in database-backed mode.
3. **mongo-service:** Kubernetes successfully resolved the internal MongoDB Service.
4. **27017:** The correct MongoDB port.
5. **tictactoe:** The database being used.

We also have:

```json
{
  "code": "REQ_200",
  "message": "Request completed",
  "statusCode": 200
}
```

This confirms that the application successfully handled HTTP requests, including the scoreboard API request.

#  2-tier deployment with PV for database

## Persistent Volumes (PV) and Persistent Volume Claims (PVC)

Building on the existing Tic-Tac-Toe application, we can make the MongoDB data persistent so that it is not lost when the MongoDB pod is restarted or recreated.

| Component | Purpose |
|-----------|---------|
| PV (Persistent Volume) | Represents storage available to Kubernetes. |
| PVC (Persistent Volume Claim) | Requests a certain amount of storage from a PV. |
| Volume mount | Connects the storage to a directory inside the MongoDB container. |

![alt text](<Kubernetes MongoDB Persistent Storage Infographic.png>)

![alt text](kubernetes_cluster_with_persistent_storage.png)

## Create new folder for the persistent-storage version

Create a directory called `local-ttt-app-mongo-pv-deploy` in the `yaml-defintions` directory:

`mkdir local-ttt-app-mongo-pv-deploy`

![alt text](image-12.png)

## Copy the 4 existing Kubernetes configuration files into the local-ttt-app-mongo-pv-deploy directory

`cp local-ttt-app-mongo-deploy/* local-ttt-app-mongo-pv-deploy/`

![alt text](image-13.png)

## Create the Persistent Volume Claim (PVC)


1. **PVC (Persistent Volume Claim):** A request for storage
2. We'll request **1Gi (1 gibibyte)**, which is sufficient for this small learning project
3. Kubernetes will use the existing `hostpath` StorageClass to provision the Persistent Volume (PV) automatically

Change to the `local-ttt-app-mongo-pv-deploy` directory.

Then create the `mongo-pvc.yml` file:

`touch mongo-pvc.yml`

![alt text](image-14.png)

Add the code below into the `mongo-pvc.yml` file:

```
# PersistentVolumeClaim API version
apiVersion: v1

# Resource type
kind: PersistentVolumeClaim

# PVC metadata
metadata:
  # Name of the Persistent Volume Claim
  name: mongo-pvc

# PVC specification
spec:
  # Defines how the volume can be mounted
  accessModes:
    # Volume can be mounted as read-write by a single node
    - ReadWriteOnce

  # Storage resource requirements
  resources:
    requests:
      # Request 1 GiB of storage
      storage: 1Gi

  # StorageClass used to dynamically provision the volume
  storageClassName: hostpath
```

## Create the PVC in Kubernetes

This tells Kubernetes to create the storage request.

`kubectl apply -f mongo-pvc.yml`

![alt text](image-15.png)

## Check the PVC 

`kubectl get pvc`

This shows the Persistent Volume Claims and whether they have been connected to storage.

Status `Bound`  = successfully connected

![alt text](image-16.png)

## Check the Persistent Volume

`kubectl get pv`

![alt text](image-17.png)

The output confirms that Kubernetes automatically created a Persistent Volume and connected it to the PVC.

Status `Bound`  = successfully connected

## Connect MongoDB to the persistent storage

Update `mongo-deploy.yml` with:

```
# Kubernetes Deployment API version
apiVersion: apps/v1

# Resource type
kind: Deployment

metadata:
  # Name of the MongoDB deployment
  name: mongo-deployment

spec:
  # Run one MongoDB pod
  replicas: 1

  # Match pods with the label app: mongo
  selector:
    matchLabels:
      app: mongo

  # Pod template configuration
  template:
    metadata:
      # Labels assigned to the pod
      labels:
        app: mongo

    spec:
      containers:
        # MongoDB container configuration
        - name: mongo

          # Use MongoDB version 7.0 image
          image: mongo:7.0

          ports:
            # Expose MongoDB default port inside the container
            - containerPort: 27017

          # Connect persistent storage to MongoDB
          volumeMounts:
            # Reference the volume defined below
            - name: mongo-storage

              # Mount path where MongoDB stores database files
              mountPath: /data/db

      # Define the storage used by the pod
      volumes:
        # Name of the volume available to the container
        - name: mongo-storage

          # Use an existing PersistentVolumeClaim
          persistentVolumeClaim:

            # PVC that provides persistent storage for MongoDB
            claimName: mongo-pvc
```

### What was added?

| Configuration | Purpose |
|---------------|---------|
| `volumeMounts` | Connects storage to the MongoDB container |
| `mountPath: /data/db` | MongoDB's database storage directory |
| `volumes` | Defines the volume available to the pod |
| `claimName: mongo-pvc` | Connects the volume to your existing PVC |

## Deploy the updated MongoDB configuration

`kubectl apply -f mongo-deploy.yml`

![alt text](image-18.png)

## Check the MongoDB pod

`kubectl get pods`

![alt text](image-19.png)


## Verify the volume is mounted

`kubectl describe pod mongo-deployment-77c68989cb-vx9tk`

### This confirms MongoDB is using the mounted storage directory.
![alt text](image-20.png)


### This confirms the volume is connected to the PVC
![alt text](image-21.png)

## Open the app and play the game to add scores to the global scoreboard.

`http://localhost:30001/`

![alt text](image-22.png)
![alt text](image-23.png)

## Delete the MongoDB pod temporarily to test whether persistent storage (PV and PVC) is working. (The database storage is not being deleted).

## Find the MongoDB pod

`kubectl get pods`

![alt text](image-24.png)

The MongoDB pod in this case is:

`mongo-deployment-77c68989cb-vx9tk`

The three ttt-app pods are the application, so these shall be left alone.

## Delete the MongoDB pod

`kubectl delete <name-of-pod>`

`kubectl delete pod mongo-deployment-77c68989cb-vx9tk`

 

![alt text](image-25.png)

## Check whether Kubernetes created a replacement

`kubectl get pods`

![alt text](image-26.png)

The new MongoDB pod replacement is `mongo-deployment-77c68989cb-8ctls`, it is Running and Ready

## Check whether the scores survived after the mongoDB pod was deleted and then re-created.

![alt text](image-27.png)
![alt text](image-28.png)

The scores remained on the scoreboard after the MongoDB pod was deleted and recreated. This confirms that MongoDB is using the persistent volume rather than relying on storage inside the original pod.

## Verify the PV and PVC are still bound

`kubectl get pvc`

`kubectl get pv`

Status `Bound`  = successfully connected


![alt text](image-29.png)

## Removing the PV

## Stop MongoDB temporarily

We stop MongoDB because its pod is currently using the PVC to access the persistent storage. Kubernetes may prevent the PVC from being deleted while a pod is actively using it. This is called PVC protection.

`kubectl scale deployment mongo-deployment --replicas=0`

![alt text](image-30.png)

## Delete the PVC

Because the PV has a Delete reclaim policy, Kubernetes should automatically delete the associated PV as well.

`kubectl delete pvc mongo-pvc`

![alt text](image-31.png)

## Verify that the PV has also been deleted

`No resources found` = confirms that the PV has been deleted.

![alt text](image-32.png)

## Verify that the PVC has also been removed

`No resources found in default namespace` = confirms that the PVC has been deleted.

`kubectl get pvc`

![alt text](image-33.png)


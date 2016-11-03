## Docker Introduction
### 基本概念
1. **Docker Image**
	Docker Image是一个只读的模板，一个Docker Image可以是一个完整的Ubuntu系统，也可以是包括了Ubuntu系统、JDK以及一个可运行的Tomcat程序。
1. **Docker Container**
	对比Docker Image，Docker Container是通过Docker Image来创建的一个运行时的容器，容器之间通过namespace和cgroup的技术进行资源上的隔离。
3. **Docker仓库**
	制作好的Docker Image需要一个统一的地方来存储，可以使用公网存在的Docker 仓库（Docker Hub），也可以使用私有的Docker 仓库(docker.baifendian.com).通过*docker push*和*docker pull*实现Docker Image的上传和下载。
4. **Docker Daemon****
	运行在主机上的守护进程，负责Docker Container的生命周期以及本地Docker Image的存储。
### 如何制作一个Docker Image
1. 准备好一个应用程序
	目录结构：
	`project`
	`\_Dockerfile`
	`\_hello`
	`\_hello.go`
2. 编译Go程序
	On Mac OS
	`export GOARCH=amd64; export GOOS=linux; go build hello.go `
	On Linux
	`go build hello.go`
2. 编写Dockefile
	`FROM golang:alpine `# 选择一个基础镜像
	`COPY hello /`# 将本地的二进制文件拷贝到根目录下
	`CMD ["/hello"]`# 执行
3. 制作Docker Image
	`docker build -t yancey_hello .`
### Docker Container
1. 运行一个Docker Container
	`docker run yancey_hello`
1. 如何区分不同版本的Docker Image？
	每一个Docker Image可以通过tag来区分其版本号，默认为latest
	`docker build -t yancey_hello:v1.0 .`
2. 查看正在运行的Docker Container
	`docker ps`
3. 查看应用日志
	`docker logs`
4. 停止一个正在运行的Docker Container
	`docker stop`
5. 后台运行一个Docker Continaer
	`docker run -d yancey_hello`
### Docker Storage
* Docker Container运行时产生的数据会随着Docker Container的删除而删除
* Docker Container中的数据可以通过`-v`参数挂载到宿主机，以实现持久化存储
`docker run -d -v $GOPATH/src/github.com/Yancey1989/docker_docs/:/data/ yancey_hello`

### Docker Networking
总体来说Docker的网络模式分为三种
1. Host模式
	使用宿主机的网络栈，不对网络虚拟化
	`docker run --host="host" -d yancey_hello`
2. NAT模式
	使用NAT模式将内部端口映射到主机中某一个端口上
	`docker run -p 8080:18080 -d yancey_hello`
	将所有端口随机映射到宿主机的端口
	`docker run -P -d yancey_hello`
	`yancey@ yancey-macbook docker-docs$docker ps
	`CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS                     NAMES
	`a8248ef77578        yancey_hello        "/hello"            1 seconds ago       Up 1 seconds        0.0.0.0:32768->8080/tcp   condescending_jones`

3. Bridge（桥接）模式
	将Docker Container桥接到某一个宿主机的某个网桥上
	`docker run --network="bridge name" -d yancey_hello`

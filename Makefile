
IMAGE_NAME?=cr.loongnix.cn/delron/fastdfs:v5.11

image:
	docker build -t ${IMAGE_NAME} .

clean:
	docker rmi fastdfs_delron:test


start_tracker:
	docker run -d --network=host --name tracker ${image} tracker

start_storage:
	docker run -d --network=host --name storage -e TRACKER_SERVER=10.130.0.170:22122 -e GROUP_NAME=group1 ${image} storage

push:
	docker push ${IMAGE_NAME}

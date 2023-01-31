build_image:
	docker build -t fastdfs_delron:test .

clean:
	docker rmi fastdfs_delron:test

image = fastdfs_delron:test

start_tracker:
	docker run -d --network=host --name tracker ${image} tracker

start_storage:
	docker run -d --network=host --name storage -e TRACKER_SERVER=10.130.0.170:22122 -e GROUP_NAME=group1 ${image} storage

tag:
	docker tag ${image} cr.loongnix.cn/delron/fastdfs:V5.11

push:
	docker push cr.loongnix.cn/delron/fastdfs:V5.11

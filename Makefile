REPO=cpingwang
APP=quoters
VER=0.0.1-SNAPSHOT
compile:
	./mvnw clean package

run: compile
	./mvnw spring-boot:run
    
run-by-java: compile
	java -jar target/$(APP)-$(VER).jar
    
build-image-by-pack: compile
	pack build cpingwang/$(APP) --path target/$(APP)-$(VER).jar --builder cnbs/sample-builder:bionic
    
build-image-by-mvn: compile
	./mvnw spring-boot:build-image  -Dspring-boot.build-image.imageName=$(REPO)/$(APP)

push-image: build-image-by-mvn
	docker push $(REPO)/$(APP)

undeploy:
	kubectl delete -f deploy.yml

deploy:	undeploy push-image 
	kubectl apply -f deploy.yml

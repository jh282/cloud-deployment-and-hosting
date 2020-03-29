[
  {
    "name": "${name}",
    "image": "${image}:latest",
    "essential": true,
    "portMappings": [
      {
        "containerPort": ${container_port},
        "hostPort": 0
      }
    ],
    "memory": 100,
    "cpu": 10
  }
]

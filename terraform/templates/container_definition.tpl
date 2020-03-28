[
  {
    "command": [
       "/bin/sh -c \"echo '<html> <head> <title>Amazon ECS Sample App</title> <style>body {margin-top: 40px; background-color: #333;} </style> </head><body> <div style=color:white;text-align:center> <h1>Amazon ECS Sample App</h1> <h2>Congratulations!</h2> <p>Your application is now running on a container in Amazon ECS.</p> </div></body></html>' >  /usr/local/apache2/htdocs/index.html && httpd-foreground\""
    ],
    "entryPoint": [
       "sh",
       "-c"
    ],
    "name": "${name}",
    "image": "${image}:latest",
    "essential": true,
    "portMappings": [
      {
        "containerPort": ${container_port},
        "hostPort": 0
      }
    ],
    "memory": 200,
    "cpu": 10
  }
]

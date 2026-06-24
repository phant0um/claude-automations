---
title: "Learn Go: The complete course"
type: source
source: "Clippings/Learn Go The complete course.md"
created: 2026-06-23
ingested: 2026-06-23
score: C
tags: [concurso, source-page]
---

## Tese central
./main.go:30:27: too few values in Person{...}
```
```
var p4 = Person{"Bruce", "Wayne", 40}
fmt.Println("Person 4:", p4)
```
We can also declare an anonymous struct. ```
func main() {
    var p1 Person
    fmt.Println("Person 1:", p1)
    var p2 = Person{
        FirstName: "Karan",
        LastName:  "Pratap Singh",
        Age:       22,
    }
    fmt.Println("Person 2:", p2)
    var p3 = Person{
        FirstName: "Tony",
        LastName:  "Stark",
    }
    fmt.Println("Person 3:", p3)
   

## Argumentos principais
### Table of Contents
Hey, welcome to the course, and thanks for learning Go. I hope this course provides a great learning experience!

### What is Go?
Go (also known as *Golang*) is a programming language developed at Google in 2007 and open-sourced in 2009.
It focuses on simplicity, reliability, and efficiency. It was designed to combine the efficacy, speed, and safety of a statically typed and compiled language with the ease of programming of a dynamic language to make programming more fun again.
In a way, they wanted to combine the best parts of Python and C++ so that they can build reliable systems that can take advantage of multi-core processors.

### Why learn Go?
Before we start this course, let us talk about why we should learn Go.

### 1\. Easy to learn
Go is quite easy to learn and has a supportive and active community.
And being a multipurpose language you can use it for things like backend development, cloud computing, and more recently, data science.

### 2\. Fast and Reliable
Which makes it highly suitable for distributed systems. Projects such as Kubernetes and Docker are written in Go.

### 3\. Simple yet powerful
Go has just 25 keywords which makes it easy to read, write and maintain. The language itself is concise.
But don't be fooled by the simplicity, Go has several powerful features that we will later learn in the course.

### 4\. Career opportunities
Go is growing fast and is being adopted by companies of any size. and with that, comes new high-paying job opportunities.
I hope this made you excited about Go. Let's start this course.

### Installation and Setup
In this tutorial, we will install Go and setup our code editor.

### Download
We can install Go from the [downloads]() section.

### Installation
*These instructions are from the [official website]().*

### MacOS
1. Open the package file you downloaded and follow the prompts to install Go. The package installs the Go distribution to `/usr/local/go`. The package should put the `/usr/local/go/bin` directory in your `PATH` environment variable. You may need to restart any open Terminal sessions for the change to take effect.
2. Verify that you've installed Go by opening a command prompt and typing the following command:
```

### Linux
1. Remove any previous Go installation by deleting the `/usr/local/go` folder (if it exists), then extract the archive you just downloaded into `/usr/local`, creating a fresh Go tree in `/usr/local/go`:
```
$ rm -rf /usr/local/go && tar -C /usr/local -xzf go1.18.1.linux-amd64.tar.gz

### Windows
1. Open the MSI file you downloaded and follow the prompts to install Go.
By default, the installer will install Go to Program Files or Program Files (x86). You can change the location as needed. After installing, you will need to close and reopen any open command prompts so that changes to the environment made by the installer are reflected at the command prompt.
2. Verify that you've installed Go.

### VS Code
In this course, I will be using [VS Code]() and you can download it from [here]().
*Feel free to use any other code editor you prefer.*

### Extension
Make sure to also install the [Go extension]() which makes it easier to work with Go in VS Code.
This is it for the installation and setup of Go, let's start the course and write our first hello world!


## Key insights
- "[[Karan Pratap Singh]]"
- init statement**: which is executed before the first iteration.
- condition expression**: which is evaluated before every iteration.
- post statement**: which is executed at the end of every iteration.
- src**: contains Go source code organized in a hierarchy.
- pkg**: contains compiled package code.
- bin**: contains compiled binaries and executables.
- Go is smart enough to interpret our function call correctly, and hence, pointer receiver method calls are just syntactic sugar provided by Go for convenience.
- We can omit the variable part of the receiver as well if we're not using it.
- Methods are not limited to structs but can also be used with non-struct types as well.

## Exemplos e evidências
See original source at `Clippings/Learn Go The complete course.md` for detailed examples, data, and benchmarks.

## Implicações para o vault
Links to existing concepts in vault.

## Links
- [[03-RESOURCES/concepts/ai-agents/harness]]
- [[03-RESOURCES/concepts/llm-ml-foundations/token]]
- [[03-RESOURCES/concepts/software-engineering/compiler]]
- [[03-RESOURCES/entities/Apple]]
- [[03-RESOURCES/entities/Uber]]
- [[03-RESOURCES/entities/Python]]
- [[03-RESOURCES/entities/Kubernetes]]

from golang:alpine
ADD hello /
EXPOSE 8080
CMD ["/hello"]

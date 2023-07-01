FROM jzollinger/baseline-workstation:rubi8

WORKDIR /root/
RUN rm -rf go  
RUN wget https://go.dev/dl/go1.20.4.linux-amd64.tar.gz
RUN sha256sum go1.20.4.linux-amd64.tar.gz | grep "698ef3243972a51ddb4028e4a1ac63dc6d60821bf18e59a807e051fee0a385bd"
RUN tar -C /usr/local -xzf go1.20.4.linux-amd64.tar.gz
RUN sed -i '4 i export PATH=$PATH:/usr/local/go/bin' ~/.bashrc
ENV PATH="$PATH:/usr/local/go/bin"

RUN eval $(go env | sed 's/^/export /'); mkdir -p "$GOPATH/src" "$GOPATH/bin"
RUN eval $(go env | sed 's/^/export /'); echo -e "GOPATH current value is '${GOPATH}'"; chmod -R 777 "${GOPATH}"


RUN go install -v golang.org/x/tools/gopls@latest
RUN go install -v github.com/go-delve/delve/cmd/dlv@latest
RUN go install -v github.com/cweill/gotests/...@latest
RUN go install -v github.com/josharian/impl@latest
RUN go install -v gotest.tools/gotestsum@latest
RUN go install -v github.com/koron/iferr@latest

RUN echo -e "finished installing $(go version)"

CMD "/bin/bash"

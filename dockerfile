FROM ubuntu:latest
SHELL ["/bin/bash", "-c"]
ENV LC_CTYPE=C.UTF-8
RUN apt-get -y update
RUN apt-get -y install git python3 curl python3-pip flex bison vim tmux wget gcc zsh sudo cmake libssl-dev psmisc htop file clang llvm bat  psmisc
RUN update-alternatives --install /usr/bin/python python /usr/bin/python3 100


# install JAVA
RUN wget https://download.java.net/java/GA/jdk21.0.2/f2283984656d49d69e91c558476027ac/13/GPL/openjdk-21.0.2_linux-x64_bin.tar.gz

RUN tar -xvf openjdk-21.0.2_linux-x64_bin.tar.gz
RUN mv jdk-21.0.2 /opt/
ENV JAVA_HOME='/opt/jdk-21.0.2'
ENV PATH="$JAVA_HOME/bin:$PATH"

RUN wget https://dlcdn.apache.org/maven/maven-3/3.9.6/binaries/apache-maven-3.9.6-bin.tar.gz
RUN tar -xvf apache-maven-3.9.6-bin.tar.gz
RUN mv  apache-maven-3.9.6 /opt
ENV M2_HOME='/opt/apache-maven-3.9.6'
ENV PATH="$M2_HOME/bin:$PATH"



# ZSH
RUN wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh ; sh ./install.sh
RUN echo "RPROMPT='%n@%m [%D{%L:%M:%S}]'" >> /root/.zshrc
RUN echo "DISABLE_AUTO_UPDATE=true" >> /root/.zshrc
RUN echo "LC_CTYPE=C.UTF-8" >> /root/.zshrc
RUN sed -i -e 's/git/zsh-autosuggestions/g'  /root/.zshrc
RUN echo "git config --add oh-my-zsh.hide-status 1 2> /dev/null" >> /root/.zshrc
RUN echo "git config --add oh-my-zsh.hide-dirty 1 2> /dev/null" >> /root/.zshrc

#NVIM 
RUN curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
RUN chmod u+x nvim.appimage
RUN ./nvim.appimage --appimage-extract
RUN ln -s /squashfs-root/AppRun /usr/bin/nvim
RUN git clone https://github.com/LazyVim/starter ~/.config/nvim



# CARGO
RUN curl https://sh.rustup.rs -sSf | bash -s -- -y
RUN echo 'source $HOME/.cargo/env' >> $HOME/.zshrc
RUN echo 'alias cat=batcat' > ~/.zshrc

# Install go 1.20 
RUN wget -P /tmp "https://dl.google.com/go/go1.21.4.linux-amd64.tar.gz"
RUN tar -C /usr/local -xzf "/tmp/go1.21.4.linux-amd64.tar.gz"
RUN rm "/tmp/go1.21.4.linux-amd64.tar.gz"

ENV GOPATH /go
ENV PATH $GOPATH/bin:/usr/local/go/bin:$PATH
RUN mkdir -p "$GOPATH/src" "$GOPATH/bin" && chmod -R 777 "$GOPATH"


RUN go install -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest
RUN go install -v github.com/projectdiscovery/httpx/cmd/httpx@latest
RUN go install -v github.com/projectdiscovery/nuclei/v3/cmd/nuclei@latest

RUN wget https://apt.llvm.org/llvm.sh
RUN chmod +x llvm.sh
RUN  ./llvm.sh 19

RUN ln -s /usr/bin/clang-19 /usr/bin/clang
RUN ln -s /usr/bin/clang++-19 /usr/bin/clang++
RUN ln -s /usr/bin/llvm-config-19 /usr/bin/llvm-config

RUN apt-get update && apt-get install -y openssh-server
RUN mkdir /var/run/sshd
RUN echo 'root:$PASS' | chpasswd
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

RUN /root/.cargo/bin/cargo install bore-cli
RUN echo -n "tmux new-session -d -s ssh -n master -d \"/usr/sbin/sshd -D\"; tmux new-window -t ssh:1123 -d \"/root/.cargo/bin/bore local 22 --to 45.32.127.181\";bash " > /entrypoint.sh
RUN chmod +x /entrypoint.sh
#ENTRYPOINT ["/entrypoint.sh"]
CMD /entrypoint.sh
#RUN tmux new-session -d -s ssh -n master -d "/usr/sbin/sshd -D"
#RUN tmux new-window -d ssh:1 -d "/root/.cargo/bin/bore local 22 --to $HOST"




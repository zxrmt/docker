docker run --rm -it -v ./:/root/zx v8 sh -c /root/zx/get_cov.sh

docker run --rm -it -w /root/zx/cov -v ./:/root/zx v8 python3 /root/zx/file_cov.py

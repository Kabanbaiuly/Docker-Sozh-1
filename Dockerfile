# ---- 1-саты: build (есепті генерациялау) ----
FROM python:3.12-alpine AS build
WORKDIR /src
COPY tools/ tools/
COPY data/ data/
RUN python tools/build_report.py

# ---- 2-саты: test (сапа қақпасы) ----
FROM build AS test
COPY tests/ tests/
RUN python -m unittest discover -s tests -v

# ---- 3-саты: финалдық образ ----
FROM python:3.12-alpine
WORKDIR /kaznu-library
COPY app/server.py .
COPY --from=test /src/out/report.json .
ENV BRANCH="Main"
ENV TOP="5"
EXPOSE 8080
CMD ["python", "server.py"]

FROM perl:latest
RUN apt-get update
RUN apt-get install --yes libgd-dev
RUN mkdir /app
RUN cd /app && git clone https://alexschroeder.ch/cgit/face-generator
RUN cd /app && git clone https://alexschroeder.ch/cgit/character-sheet-generator
RUN cd /app && cpanm --notest File::ShareDir::Install ./face-generator ./character-sheet-generator
# create a config file that points to face-generator in the same container
RUN echo "{ face_generator_url => 'http://localhost:3020' }" > character-sheet-generator.conf
CMD face-generator daemon --listen "http://*:3020" & character-sheet-generator daemon --listen "http://*:3040"

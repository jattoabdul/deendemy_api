# Deendemy

#### About Deendemy
  
##### Overview
 > Deendemy is an e-learning scholarship platform developed to provide teachers, scholars and tutors well-grounded in Islamic teachings/Arabic knowledge from anywhere around the world the opportunity of  teaching and learning of the true and beautiful teachings of Islam and the Arabic language. 
  The scholarship platform which also serves as a marketplace consists of free and affordable fee-based hands-on courses on how to read and recite the Qur'aan and its exegesis, Arabic Language, Islamic History, Jurisprudence and Civilization.
  
##### Our Mission
  > Our mission is to enable Muslim youths in particular and all other categories of Muslims across the globe, have access to, and gain good enlightenment on the beautiful teachings of Islam inshaa Allaah (God Willing) 
  
##### Our Vision
  > Our vision is to revolutionize the Islamic perspective to education  by providing cutting edge tools to ease learning processes for the Muslims around the world and thereby effect the much needed positive change on the world.
  
##### Our Values
  > Our values are derived from our DEEN; Islam  which means peace. Spreading peace and how submission to the will of ALlah should be exemplified via the following values:
  > - Diversity
  > - Excellence
  > - Experience
  > - Naturality

## Method 1: Docker Build and Run Setup

To Install all system requirements and run app:

- Install Docker
- ```$ docker-compose up --build```
- Run API Server on port `3000` e.g. [`http://127.0.01:3000`]
- Run Mailcatcher UI in development on port `1080` e.g. [`http://127.0.0.1:1080`]

To Run Rspec Test:

- ```$ docker-compose run -e "RAILS_ENV=test" deendemy_api rspec -f d```

To Run Logs in Development:

- ```$ docker-compose run deendemy_api tail -f log/development.log```

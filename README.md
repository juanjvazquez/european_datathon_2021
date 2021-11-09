# Exploring how headline topics affect A/B testing results on the Upworthy website using Machine Learning

We firstly determined through a Mann-Whitney U test, that the median percentage increase in click rate (of articles) induced by changing the headlines of packages was significantly greater than the median percentage increase in click rate induced by changing the images of packages. Within package tests which involved solely the variation of headlines, the article with the maximum click rate amongst all others of the test had a median 32.4% greater click rate than the average click rate of all the articles in the test. In contrast, for package tests which involved solely the variation of images, this figure was 25.4%, 7% less than that for headline tests. In other words, we can conclude that the headline of the package is slightly, but significantly, more important in determining how popular it is, as varying the headline causes a greater median increase in the click rate of a package.

We found that there are statistically significant differences in the *click\_rate*, *first\_place*, and *winner* variables for the different *headline* categories. For example, a test rejected the hypothesis that the mean click rate is the same for the ‘HEALTHY LIVING’ and ‘WELLNESS’ categories. Overall, this means that headline categories have a sizable impact on both user behaviour (whether or not they click on the package) and organisational behaviour (whether editors choose to publish that version of the package). However, how large that effect is compared to other factors such as the time when the tests were taken, or the detailed difference between headlines in the same topic, is yet to be investigated.

## Notes

This study was carried out as part of the team's participation in the European Regional Datathon 2021 organised by Citadel.
This submission won the **1st place 10,000€ award** and an invitation to the Data Open Championship for the team.

All authors worked equally towards the making of this project and are not listed in any particular order:
- Agathiyan Bragadeesh `<agathiyan02@gmail.com>`
- Emre Mutlu `<emre.mutlu@wadham.ox.ac.uk>`
- Juan J. Vazquez `<vazquez@tcd.ie>`
- Chun H. Yip `<chy34@cam.ac.uk>`
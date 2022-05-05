# References
[1]S. Weinstein and P. Ebert, "Data Transmission by Frequency-Division Multiplexing Using the Discrete Fourier Transform," in IEEE Transactions on Communication Technology, vol. 19, no. 5, pp. 628-634, October 1971, doi: 10.1109/TCOM.1971.1090705.

[2] Seung Hee Han and Jae Hong Lee, "An overview of peak-to-average power ratio reduction techniques for multicarrier transmission," in IEEE Wireless Communications, vol. 12, no. 2, pp. 56-65, April 2005, doi: 10.1109/MWC.2005.1421929.

[3] R. O'Neill and L. B. Lopes, "Envelope variations and spectral splatter in clipped multicarrier signals," Proceedings of 6th International Symposium on Personal, Indoor and Mobile Radio Communications, 1995, pp. 71-75 vol.1, doi: 10.1109/PIMRC.1995.476406.

[4] 孙宇彤.LTE教程原理与实现[M]. 电子工业出版社, 2016.

[5] 杨昉,何丽峰,潘长勇.OFDM原理与标准————通信技术的演进[M]. 电子工业出版社, 2013.

[6] Yong Soo Cho.MIMO-OFDM无线通信技术及MATLAB实现[M]. 电子工业出版社, 2013.

# Summary of the paper read

## [2] An overview of peak-to-average power ratio reduction techniques for multicarrier transmission
High peak-to-average power ratio of the transmit signal is a major drawback of multicarrier tranmission such as OFDM or DMT.
A number of approaches to deal with the PAPR problem:
* amplitude clipping
* clipping and filtering
* coding
* tone reservation(TR)
* tone injection(TI)
* active constellation extension(ACE)
* multiple signal representation techniques such as partial transmit sequence(PTS)
* selected mapping(SLM)
* interleaving

### THE PAPR OF MULTICARRIER SIGNAL
A multicarrier signal is the sum of many independent signals modulated onto subchannels of equal bandwidth.
* the collection of all data symbols: $$ Xn, n=0,1,...,N-1 $$
* vector: **X**=[X0,X1,...,XN-1]T
* complex baseband representation of a multicarrier signal consisting of N subcarriers


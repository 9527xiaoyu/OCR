# OCR

1.本程序只识别了身份证号码。

注：由于训练库文件过大，所以并未加入到项目，需要你自行下载。

2.下载项目后需要如下几步：

  第一步：在终端进入到项目目录后，输入  pod install 。目的是把第三方库OpenCV和TesseractOCR加入到项目。
  
  第二步：下载训练库。推荐：https://github.com/tesseract-ocr/tessdata.git
  
  第三步：将下载好的训练库文件根据需要先复制到项目目录中，格式为：根目录／二级目录／tessdata／需要的训练库，例如：OCR／OCR／tessdata／eng.traineddata。
  
  第四步：在项目中，选中targets->add files to "OCR"->选中tessdata文件夹->options->在added folders选项中选择create folder references->add

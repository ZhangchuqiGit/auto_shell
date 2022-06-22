#include "MyMainWindow.h"
#include <QCoreApplication>
#include <QDebug>

MyMainWindow::MyMainWindow(QWidget *parent)
  : QWidget(parent)
{
  this->resize(1200, 660);
  this->setWindowTitle(tr("MyWebEngineView"));

  mWebView = new QWebEngineView(this);
  mWebView->setFixedSize(960, 660);
  mWebView->setContentsMargins(0,0,0,0);

  mWebPage = new QWebEnginePage(this);                  // 定义一个page作为页面管理
  mWebChannel = new QWebChannel(this);                  // 定义一个channel作为和JS或HTML交互
  mWebChannel->registerObject("interactObj", this);     // 注册Qt对象
  mWebPage->setWebChannel(mWebChannel);					        // 把channel配置到page上，让channel作为其信使
  mWebView->setPage(mWebPage);					                // 建立page和UI上的webEngine的联系

  lab_Position = new QLabel(mWebView);
  lab_Position->setFixedSize(300, 30);
  lab_Position->setAlignment(Qt::AlignRight);
  lab_Position->move(660, 630);

  mNetWorkComboBox = new QComboBox(this);
  mNetWorkComboBox->setFixedSize(200, 40);
  mNetWorkComboBox->addItem(tr("在线地图"), 0);
  mNetWorkComboBox->addItem(tr("离线地图"), 1);
  mNetWorkComboBox->setStyleSheet("QComboBox{combobox-popup:0;}");
  QObject::connect(mNetWorkComboBox, SIGNAL(currentIndexChanged(int)), this, SLOT(slotNetWorkIndexChanged(int)));

  mMapTypeComboBox = new QComboBox(this);
  mMapTypeComboBox->setFixedSize(200, 40);
  mMapTypeComboBox->addItem(tr("街道地图"), 0);
  mMapTypeComboBox->addItem(tr("卫星地图"), 1);
  mMapTypeComboBox->setStyleSheet("QComboBox{combobox-popup:0;}");
  QObject::connect(mMapTypeComboBox, SIGNAL(currentIndexChanged(int)), this, SLOT(slotMapTypeIndexChanged(int)));

  lab_Long = new QLabel(this);
  lab_Long->setFixedSize(40, 40);
  lab_Long->setText(tr("经度:"));

  lab_Lat = new QLabel(this);
  lab_Lat->setFixedSize(40, 40);
  lab_Lat->setText(tr("纬度:"));

  lineEdit_Longitude = new QLineEdit(this);
  lineEdit_Longitude->setFixedSize(140, 40);
  lineEdit_Longitude->setText(tr("116.468278"));

  lineEdit_Latitude = new QLineEdit(this);
  lineEdit_Latitude->setFixedSize(140, 40);
  lineEdit_Latitude->setText(tr("39.922965"));

  btn_Search = new QPushButton(this);
  btn_Search->setFixedSize(200, 40);
  btn_Search->setText(tr("查询坐标"));
  QObject::connect(btn_Search, SIGNAL(clicked()), this, SLOT(onbtnSearchclicked()));

  btn_AddPoint = new QPushButton(this);
  btn_AddPoint->setFixedSize(200, 40);
  btn_AddPoint->setText(tr("添加坐标"));
  QObject::connect(btn_AddPoint, SIGNAL(clicked()), this, SLOT(onbtnAddPointclicked()));

  mLeftLayout = new QVBoxLayout();
  mLeftLayout->addWidget(mWebView);
  mLeftLayout->setSpacing(0);
  mLeftLayout->setMargin(0);

  mRightLayout = new QGridLayout();
  mRightLayout->addWidget(mNetWorkComboBox, 0, 0, 1, 0);
  mRightLayout->addWidget(mMapTypeComboBox, 1, 0, 1, 0);
  mRightLayout->addWidget(lab_Long, 2, 0);
  mRightLayout->addWidget(lab_Lat, 3, 0);
  mRightLayout->addWidget(lineEdit_Longitude, 2, 1);
  mRightLayout->addWidget(lineEdit_Latitude, 3, 1);
  mRightLayout->addWidget(btn_Search, 4, 0, 1, 0);
  mRightLayout->addWidget(btn_AddPoint, 5, 0, 1, 0);
  mRightLayout->setRowStretch(6, 1);
  mRightLayout->setSpacing(20);
  mRightLayout->setMargin(20);

  mMainLayout = new QHBoxLayout(this);
  mMainLayout->addLayout(mLeftLayout);
  mMainLayout->addLayout(mRightLayout);
  mMainLayout->setSpacing(0);
  mMainLayout->setMargin(0);

  slotNetWorkIndexChanged(0);
  slotMapTypeIndexChanged(0);
}

MyMainWindow::~MyMainWindow()
{

}

void MyMainWindow::onbtnSearchclicked()
{
  QString strLongitude = lineEdit_Longitude->text();
  QString strLatitude = lineEdit_Latitude->text();
  setCoordinate(strLongitude, strLatitude);
}

void MyMainWindow::onbtnAddPointclicked()
{
  QString strLongitude = lineEdit_Longitude->text();
  QString strLatitude = lineEdit_Latitude->text();
  addCoordinate(strLongitude, strLatitude);
}

void MyMainWindow::slotNetWorkIndexChanged(int id)
{
  QString strMapPath = "file:///" + QCoreApplication::applicationDirPath();
  switch (id) {
  case 0:
    strMapPath += "/BaiduOnline/BaiduOnlineMap.html";
    mWebPage->load(QUrl(strMapPath));
    qDebug() << "online map";
    break;
  case 1:
    strMapPath += "/BaiduOffline/BaiduOfflineMap.html";
    mWebPage->load(QUrl(strMapPath));
    qDebug() << "offline map";
    break;
  default:
    break;
  }

  mMapTypeComboBox->setCurrentIndex(0);
}

void MyMainWindow::slotMapTypeIndexChanged(int id)
{
  switch (id) {
  case 0:
    mWebView->page()->runJavaScript(QString("showStreetMap()"));
    break;
  case 1:
    mWebView->page()->runJavaScript(QString("showSatelliteMap()"));
    break;
  default:
    break;
  }
}

void MyMainWindow::getCoordinate(QString lon, QString lat)
{
  lab_Position->setText(tr("经度:%1° 纬度:%2°").arg(lon).arg(lat));
}

void MyMainWindow::setCoordinate(QString lon,QString lat)
{
  QString strMessage = QString("showAddress(\"%1\",\"%2\")").arg(lon).arg(lat);
  mWebView->page()->runJavaScript(strMessage);
}

void MyMainWindow::addCoordinate(QString lon, QString lat)
{
  QString strMessage = QString("addAddress(\"%1\",\"%2\")").arg(lon).arg(lat);
  mWebView->page()->runJavaScript(strMessage);
}

void MyMainWindow::showInfoWindow(QString lon, QString lat)
{
  QMessageBox::information(this, tr("坐标信息"), tr("经度:%1° 纬度:%2°").arg(lon).arg(lat));
}

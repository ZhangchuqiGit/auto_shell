#ifndef MYMAINWINDOW_H
#define MYMAINWINDOW_H

#include <QWidget>
#include <QLabel>
#include <QPushButton>
#include <QComboBox>
#include <QLineEdit>
#include <QHBoxLayout>
#include <QVBoxLayout>
#include <QWebEngineView>
#include <QWebEnginePage>
#include <QWebChannel>
#include <QMessageBox>

class MyMainWindow : public QWidget
{
  Q_OBJECT

public:
  MyMainWindow(QWidget *parent = 0);
  ~MyMainWindow();

private slots:
  void onbtnSearchclicked();
  void onbtnAddPointclicked();
  void slotNetWorkIndexChanged(int id);
  void slotMapTypeIndexChanged(int id);

public:
  void setCoordinate(QString lon,QString lat);
  Q_INVOKABLE void getCoordinate(QString lon,QString lat);

  void addCoordinate(QString lon,QString lat);

  Q_INVOKABLE void showInfoWindow(QString lon,QString lat);

private:
  QWebEngineView* mWebView;
  QWebEnginePage* mWebPage;
  QWebChannel *mWebChannel;
  QComboBox* mNetWorkComboBox;
  QComboBox* mMapTypeComboBox;
  QLabel* lab_Long;
  QLabel* lab_Lat;
  QLabel* lab_Longitude;
  QLabel* lab_Position;
  QLineEdit* lineEdit_Longitude;
  QLineEdit* lineEdit_Latitude;
  QPushButton* btn_Search;
  QPushButton* btn_AddPoint;

  QHBoxLayout* mMainLayout;
  QGridLayout* mRightLayout;
  QVBoxLayout* mLeftLayout;
};

#endif // MYMAINWINDOW_H

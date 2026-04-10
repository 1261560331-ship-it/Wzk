// VehicleData.cpp
#include "speedCtrl.h"
#include <QTimer>
#include <QRandomGenerator>

SpeedCtrl::SpeedCtrl(QObject *parent)
    : QObject(parent), m_updateTimer(new QTimer(this)) {
    connect(m_updateTimer, &QTimer::timeout, this, [this]() {
            // 模拟实时数据更新
            m_speed = 0 + QRandomGenerator::global()->bounded(100); // 0~100 km/h
            m_tirePressure = 2.2 + QRandomGenerator::global()->bounded(60) / 100.0; // 2.2~2.8 bar
            m_oilPercent = 0+ QRandomGenerator::global()->bounded(100);

            // 触发属性变更信号，通知 QML 更新
            emit speedChanged();
            emit tirePressureChanged();
            emit oilPercentChanged();
        });

        m_updateTimer->start(1000); // 每秒更新一次
}
SpeedCtrl::~SpeedCtrl(){}
double SpeedCtrl::speed() const { return m_speed; }
double SpeedCtrl::tirePressure() const { return m_tirePressure; }
uchar  SpeedCtrl::oilPercent() const{return m_oilPercent;}

void SpeedCtrl::setSpeed(double newSpeed) {
    if (qFuzzyCompare(m_speed, newSpeed)) return;
    m_speed = newSpeed;
    emit speedChanged();
}

void SpeedCtrl::setTirePressure(double newPressure) {
    if (qFuzzyCompare(m_tirePressure, newPressure)) return;
    m_tirePressure = newPressure;
    emit tirePressureChanged();
}
void SpeedCtrl::setOilPercent(uchar newOilPercent){
    if (m_oilPercent == newOilPercent) return;
    m_oilPercent = newOilPercent;
    emit oilPercentChanged();
}

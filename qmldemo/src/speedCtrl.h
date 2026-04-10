#pragma once
#include <QObject>
#include <QTimer>

class SpeedCtrl: public QObject
{
public:
    explicit
    SpeedCtrl(QObject *parent = nullptr);
        ~SpeedCtrl();
    Q_OBJECT
        Q_PROPERTY(double speed READ speed WRITE setSpeed NOTIFY speedChanged)
        Q_PROPERTY(double tirePressure READ tirePressure WRITE setTirePressure NOTIFY tirePressureChanged)
        Q_PROPERTY(uchar oilPercent READ oilPercent WRITE setOilPercent NOTIFY oilPercentChanged)

    public:

        double speed() const;
        double tirePressure() const;
        uchar  oilPercent() const;

    public slots:
        void setSpeed(double newSpeed);
        void setTirePressure(double newPressure);
        void setOilPercent(uchar newOilPercent);

    signals:
        void speedChanged();
        void tirePressureChanged();
        void oilPercentChanged();

    private:
        double m_speed = 0.0;
        double m_tirePressure = 2.3;
        uchar  m_oilPercent = 0;
        QTimer *m_updateTimer;
};

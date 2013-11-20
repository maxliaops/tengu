#define _US 0x5553
#define _DS 0x4453
#define _LS 0x4C53
#define _RS 0x5253
#define _UL 0x554C
#define _DL 0x444C
#define _UR 0x5552
#define _DR 0x4452

#define _SS 0x5353

#define IN1 7
#define IN2 8
#define IN3 12
#define IN4 13
#define ENA 10
#define ENB 11

#define LOWSPEED  175
#define MIDSPEED  175
#define HIGHSPEED 250



uint16_t value;

uint8_t r_buffer[4];

uint8_t number;
uint8_t command;


void setup()
{
    Serial.begin(9600);

    pinMode(IN1, OUTPUT);
    pinMode(IN2, OUTPUT);
    pinMode(IN3, OUTPUT);
    pinMode(IN4, OUTPUT);
    run(0);
}

void loop()
{

    if (Serial.available()) {
        uint8_t readbuf = Serial.read();
        Serial.print(readbuf);
        r_buffer[number] = readbuf;
        number++;

        //if (readbuf == 0x3B) {
            if (number == 2) {
                 value = (r_buffer[0] << 8) | (r_buffer[1]);
                 number = 0;
                 command = 1;
            }

            //number = 0;
            //command = 1;
        //}
    }

    if (command) {
        command = 0;

        switch (value) {
        case _SS:
            run(0);
            break;

        case _US:
            run(1);
            break;

        case _DS:
            run(2);
            break;

        case _LS:
            run(3);
            break;

        case _RS:
            run(4);
            break;

        case _UL:
            run(5);
            break;

        case _UR:
            run(6);
            break;

        case _DL:
            run(7);
            break;

        case _DR:
            run(8);
            break;

        }

    }
}


void left_wheel_stop()
{
    digitalWrite(IN3, LOW);
    digitalWrite(IN4, LOW);

    analogWrite(ENB, 0);
}

void left_wheel_forward(int speed)
{
    digitalWrite(IN3, HIGH);
    digitalWrite(IN4, LOW);
    analogWrite(ENB, speed);

}

void left_wheel_backward(int speed)
{
    digitalWrite(IN3, LOW);
    digitalWrite(IN4, HIGH);
    analogWrite(ENB, speed);

}

void right_wheel_stop()
{
    digitalWrite(IN1, LOW);
    digitalWrite(IN2, LOW);

    analogWrite(ENA, 0);
}

void right_wheel_forward(int speed)
{
    digitalWrite(IN1, HIGH);
    digitalWrite(IN2, LOW);

    analogWrite(ENA, speed);
}

void right_wheel_backward(int speed)
{
    digitalWrite(IN1, LOW);
    digitalWrite(IN2, HIGH);

    analogWrite(ENA, speed);
}

void run(int direct)
{
    Serial.println(direct);
    switch (direct) {
    case 0:
        left_wheel_stop();
        right_wheel_stop();
        break;

    case 1:
        left_wheel_forward(MIDSPEED);
        right_wheel_forward(MIDSPEED);
        break;

    case 2:
        left_wheel_backward(MIDSPEED);
        right_wheel_backward(MIDSPEED);
        break;

    case 3:
        left_wheel_backward(MIDSPEED);
        right_wheel_forward(MIDSPEED);
        break;

    case 4:
        left_wheel_forward(MIDSPEED);
        right_wheel_backward(MIDSPEED);
        break;

    case 5:
        left_wheel_forward(LOWSPEED);
        right_wheel_forward(HIGHSPEED);
        break;

    case 6:
        left_wheel_forward(HIGHSPEED);
        right_wheel_forward(LOWSPEED);
        break;

    case 7:
        left_wheel_backward(LOWSPEED);
        right_wheel_backward(HIGHSPEED);
        break;

    case 8:
        left_wheel_backward(HIGHSPEED);
        right_wheel_backward(LOWSPEED);
        break;

    }
}

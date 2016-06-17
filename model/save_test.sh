echo "Enter the name of the test: "
read TEST_NAME

TEST_DIR=tests/"$TEST_NAME"
mkdir -p $TEST_DIR
cp fake.txt real.txt angles.txt $TEST_DIR

echo "Enter your test data here." > $TEST_DIR/info.txt
geany $TEST_DIR/info.txt

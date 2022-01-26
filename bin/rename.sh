BUCKET=$1
FILES=$(aws s3api list-objects --bucket ${BUCKET} --delimiter '.' | jq -r '.Contents[] | select(.Size > 0) | .Key')
for i in $FILES
do
  aws s3 mv s3://$BUCKET/${i} s3://$BUCKET/${i}.jpg
done   

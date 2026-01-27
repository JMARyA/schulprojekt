default:
    @just --list

meetings:
    mdq -c file.name -c date -c start_time -c end_time -c actors -f '{"actors": {"$exists": true }}'

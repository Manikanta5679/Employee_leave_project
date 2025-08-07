from fastapi import FastAPI
from pydantic import BaseModel
from typing import List

app = FastAPI()

class LeaveForm(BaseModel):
    name: str
    emp_id: int
    reason: str

leave_requests = []

@app.get("/")
def read_root():
    return {"status": "Backend is running"}

@app.post("/leave")
def apply_leave(form: LeaveForm):
    leave_requests.append(form)
    return {"message": "Leave request submitted"}

@app.get("/leaves")
def get_leaves():
    return leave_requests

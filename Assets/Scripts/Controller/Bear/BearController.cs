using System;
using System.Collections;
using MonsterController;
using UnityEngine;
using UnityEngine.AI;
using Random = UnityEngine.Random;
using State = Define.BearState;

namespace BearController
{
    public class BearState : MonsterState
    {
        protected enum DirectMode
        {
            FastDirection,
            KeepMoving,
        }

        protected DirectMode directMode;

        protected Bear bear => monster as Bear;

        protected bool isOffMesh;
        protected bool isChangedState;

        protected float attackCooldown = 3.0f;
        protected float rushCooldown = 10.0f;
        protected float roarCooldown = 200.0f;
        
        protected float velocity;
        protected int idInt;

        protected float distanceToTarget;
        protected float angleToTarget;

        protected float moreSpeed = 1.0f;

        protected bool canMove;

        public BearState(Creature owner) : base(owner) { }

        public override void Update()
        {
            attackCooldown -= Time.deltaTime;
            rushCooldown -= Time.deltaTime;
            roarCooldown -= Time.deltaTime;

            bear.angleToTarget = angleToTarget;

            Move();

            if (target != null)
            {
                distanceToTarget = Vector3.Distance(bear.MoveTarget.position, bear.transform.position);
                angleToTarget = Vector3.SignedAngle(bear.transform.forward, bear.MoveTarget.position - bear.transform.position, Vector3.up);
            }
            else
            {
                distanceToTarget = bear.Data.TrackingDistance * 2;
            }
        }

        public override void FixedUpdate()
        {
            if (bear.state == State.Idle)
                return;

            if (Physics.Raycast(bear.Body.transform.position + Vector3.up, Vector3.down, out var hit, Mathf.Infinity))
            {
                Vector3 normal = hit.normal;

                var angle = Vector3.SignedAngle(bear.Body.transform.forward, normal, bear.Body.transform.right) + 90;

                bear.slopeAngle = angle;
                bear.transform.localRotation = Quaternion.Slerp(bear.transform.localRotation,
                    Quaternion.Euler(angle, bear.transform.eulerAngles.y, 0), Time.fixedDeltaTime);
            }

        }


        // 움직임 멈춤 Enter에서 쓰세요
        protected void StopMove()
        {
            bear.Agent.isStopped = true;
        }

        // 움직임 시작 Enter에서 쓰세요
        protected void StartMove()
        {
            bear.Agent.isStopped = false;
        }

        // 움직임 모드 Enter에서 쓰세요
        // FastDirection : 각도에 따라 속도가 달라짐
        // KeepMoving : vertical로 속도 제어
        protected void ChangeDirectMode(DirectMode directMode)
        {
            this.directMode = directMode;
        }

        // 움직일 위치 설정 Update에서 쓰거나 Enter에서 쓰거나
        protected void SetMoveTargetPos(Vector3 pos)
        {
            bear.MoveTarget.position = pos;
        }


        // MoveTarget으로 움직임 (Update에서 실행 중)
        private void Move()
        {
            bear.Agent.destination = bear.MoveTarget.position;

            if (bear.Agent.hasPath)
            {
                if (bear.Agent.isOnOffMeshLink)
                {
                    if (isOffMesh == false)
                    {
                        isOffMesh = true;
                        OffMeshLinkData link = bear.Agent.currentOffMeshLinkData;
                        bear.StartCoroutine(JumpCoroutine(link, link.startPos.y < link.endPos.y));
                    }
                }
                else
                {
                    isOffMesh = false;

                    Vector3 dir = (bear.Agent.steeringTarget - bear.transform.position).normalized;
                    Vector3 animDir = bear.transform.InverseTransformDirection(dir);
                    bool isFacingMoveDirection = bear.FaceCheck < Vector3.Dot(dir, bear.transform.forward);

                    bear.Anim.SetFloat("Horizontal", animDir.x * 2.0f, 0.25f, Time.deltaTime);

                    switch (directMode)
                    {
                        case DirectMode.FastDirection:
                            bear.Anim.SetFloat("Vertical", isFacingMoveDirection ? animDir.z * velocity : 0.0f, 0.25f, Time.deltaTime);
                            break;
                        case DirectMode.KeepMoving:
                            bear.Anim.SetFloat("Vertical", velocity, 0.25f, Time.deltaTime);
                            break;
                    }
                    

                    if (Vector3.Distance(bear.transform.position, bear.Agent.destination) < bear.Agent.radius)
                    {
                        bear.Agent.ResetPath();
                    }
                }
            }
            else
            {
                bear.Anim.SetFloat("Horizontal", 0.0f, 0.25f, Time.deltaTime);
                bear.Anim.SetFloat("Vertical", 0.0f, 0.25f, Time.deltaTime);
            }
        }

        // 점프 코루틴 (Update에서 판단 중)
        private IEnumerator JumpCoroutine(OffMeshLinkData link, bool upward)
        {
            Vector3 dir = (link.endPos - link.startPos).normalized;
            float heigth = dir.y;
            dir.y = 0.0f;
            float distance = dir.magnitude;
            dir.Normalize();

            float angle = Mathf.Atan2(heigth, distance) * Mathf.Rad2Deg;
            while (true)
            {
                Vector3 animDir = bear.transform.InverseTransformDirection(dir);
                bear.transform.position = Vector3.Lerp(bear.transform.position, link.startPos, Time.deltaTime * 3.0f);

                bear.Anim.SetFloat("Horizontal", animDir.x * 2.0f, 0.25f, Time.deltaTime);
                bear.Anim.SetFloat("Vertical", 0.0f, 0.25f, Time.deltaTime);
                bear.transform.forward = Vector3.Lerp(bear.transform.forward, dir, Time.deltaTime);

                bool isRotationGood = 0.9f < Vector3.Dot(dir, bear.transform.forward);
                if (isRotationGood)
                {
                    bear.transform.position = link.startPos;
                    break;
                }

                yield return null;
            }

            float time = 1.5f;
            float totalTime = time;

            AnimationCurve animCurve = upward ? bear.UpwardCurve : bear.DownwardCurve;
            Quaternion originRot = bear.transform.rotation;

            bear.Anim.CrossFade("Jump/Fall", 0.2f);

            while (time > 0.0f)
            {
                time = Mathf.Max(0.0f, time - Time.deltaTime);
                bear.transform.rotation = Quaternion.Slerp(originRot, Quaternion.Euler(-angle, bear.transform.eulerAngles.y, 0.0f), animCurve.Evaluate(Mathf.Sin(time / totalTime * Mathf.PI)));
                bear.transform.position = Vector3.Lerp(link.startPos, link.endPos, bear.UpwardCurve.Evaluate(1 - time / totalTime));
                yield return null;

                bear.transform.position = link.endPos;
                bear.Agent.CompleteOffMeshLink();
            }
        }
    }
}
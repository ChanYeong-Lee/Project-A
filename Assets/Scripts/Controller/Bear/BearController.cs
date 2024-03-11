using System;
using System.Collections;
using MonsterController;
using Unity.VisualScripting.FullSerializer;
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
            Auto,
            Manual,
        }

        protected DirectMode directMode;

        protected Bear bear => monster as Bear;

        protected bool isOffMesh;

        protected int randomValue;

        protected float actualVelocity;


        protected float velocity;
        protected float angularVelocity = 2.0f;

        protected float horizontal;
        protected float vertical;

        protected float distance;
        protected float angle;

        protected bool targeting;
        protected bool animated;

        public BearState(Creature owner) : base(owner) { }

        public override void Update()
        {
            CheckMove();

            distance = Vector3.Distance(bear.MoveTarget.position, bear.transform.position);
            angle = Vector3.SignedAngle(bear.transform.forward, bear.MoveTarget.position - bear.transform.position, Vector3.up);

        }

        public override void FixedUpdate()
        {
            CheckSlope();
        }

        protected void AttackTransition()
        {
            Vector3 attackDir = (bear.MoveTarget.position - bear.transform.position).normalized;
            if (bear.attackCooldownDelta < 0.0f && 0.8f < Mathf.Abs(Vector3.Dot(bear.transform.forward, attackDir)) && Vector3.Distance(bear.MoveTarget.position, bear.transform.position) < 10.0f)
            {
                ChangeState(State.Attack);
            }
        }

        // �ٴ� ���� ��ü ȸ��
        private void CheckSlope()
        {
            Vector3 origin = bear.transform.position;

            //int groundLayerIndex = LayerMask.NameToLayer("Ground");
            //int layerMask = (1 << groundLayerIndex);

            RaycastHit slopeHit;

            if (Physics.Raycast(origin + Vector3.up, Vector3.down, out slopeHit, 100.0f, bear.GroundLayer))
            {
                Debug.DrawLine(origin + Vector3.up, slopeHit.point, Color.red);
                Quaternion targetRot = Quaternion.FromToRotation(bear.transform.up, slopeHit.normal) * bear.transform.rotation;
                bear.transform.rotation = Quaternion.Lerp(bear.transform.rotation, targetRot, Time.deltaTime * 10.0f);
            }
        }

        // ������ ��� Enter���� ������
        // FastDirection : ������ ���� �ӵ��� �޶���
        // KeepMoving : vertical�� �ӵ� ����
        protected void ChangeDirectMode(DirectMode directMode)
        {
            this.directMode = directMode;
        }

        // ������ ��ġ ���� Update���� ���ų� Enter���� ���ų�
        protected void SetMoveTargetPos(Vector3 pos)
        {
            bear.MoveTarget.position = pos;
            bear.Agent.SetDestination(bear.MoveTarget.position);
        }

        // MoveTarget���� ������ (Update���� ���� ��)
        private void CheckMove()
        {
            actualVelocity = velocity * (1.0f - bear.decreaseVelocityRate);

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
                    // ���� ��ǥ���� ���� ��ǥ�� ��ȯ 
                    Vector3 animDir = bear.transform.InverseTransformDirection(dir);
                    // �̵��� ������ z�� 0 �����̸� Ÿ���� �ڿ� ����
                    bool isFacingMoveDirection = 0.0f < Vector3.Dot(dir, bear.transform.forward);

                    //  animDir�� 0���� ũ�� �������� �����̸� ���� x �� ���.
                    //  Ʋ���� -2f - animDir.x �̸� �������� �ڵ���. 2f - animDir.x�� ��� ���������� �ڵ��� 
                    horizontal = 0.0f < animDir.z ? animDir.x : animDir.x < 0 ? -2.0f - animDir.x : 2.0f - animDir.x;
                    
                    //Ÿ���� �ڿ� ������ ������ ���� �ӵ��� 0. �ڷ� �ٷ� ���� ���ؼ�
                    //Ÿ���� �� �չ����� 90�� ���� ���� ��� ������ ���� �ӵ� �״�� ���
                    vertical = isFacingMoveDirection ? animDir.z * actualVelocity : 0.0f;

                    switch (directMode)
                    {
                        case DirectMode.Auto:
                            bear.Anim.SetFloat("Vertical", vertical, 0.25f, Time.deltaTime);
                            bear.Anim.SetFloat("Horizontal", horizontal, 0.25f, Time.deltaTime);
                            break;
                        case DirectMode.Manual:
                            bear.Anim.SetFloat("Vertical", actualVelocity, 0.25f, Time.deltaTime);
                            bear.Anim.SetFloat("Horizontal", angularVelocity, 0.25f, Time.deltaTime);
                            break;
                    }
                    
                    if (bear.Agent.remainingDistance < 5.0f)
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

        // ���� �ڷ�ƾ (Update���� �Ǵ� ��)
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
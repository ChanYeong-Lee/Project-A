using BearController;
using UnityEngine;
using State = Define.BearState;

public class Bear : Monster
{
    [SerializeField] private Transform eyes;
    [SerializeField] private Transform body;
    [SerializeField] private LayerMask detection;
    
    private int receivedDamage;
    
    // �ν����� Ȯ�ο�
    public State state;
    public float distance;
    public float angle;
    
    public Transform Eyes => eyes;
    public Transform Body => body;
    public LayerMask Detection => detection;
    public int ReceivedDamage => receivedDamage;

    public override void Init()
    {
        base.Init();
        stateMachine.AddState(State.Idle, new IdleState(this));
        // stateMachine.AddState(State.Patrol, new PatrolState(this));
        // stateMachine.AddState(State.Run, new RunState(this));
        stateMachine.AddState(State.TakeAttack, new TakeAttackState(this));
        stateMachine.AddState(State.Trace, new TraceState(this));
        stateMachine.AddState(State.Attack, new AttackState(this));
        stateMachine.AddState(State.Dead, new DeadState(this));
        stateMachine.InitState(State.Idle);
    }

    //private void OnCollisionEnter(Collision other)
    //{
    //    if (other.gameObject.CompareTag("Arrow"))
    //    {
    //        if (currentStat.HealthPoint <= 0)
    //            return;
            
    //        var arrow = other.gameObject.GetComponent<Arrow>();
            
    //        // ������ ����
    //        receivedDamage = arrow.ArrowData.ArrowTrueDamage + (arrow.ArrowData.ArrowDamage - currentStat.Defence > 0
    //            ? arrow.ArrowData.ArrowDamage - currentStat.Defence
    //            : 0);

    //        if (state != State.Dead)
    //        {
    //            target = Managers.Game.Player.transform;
    //            stateMachine.ChangeState(State.TakeAttack);
    //        }

    //        // TODO : �÷��̾� ���� �� ȭ�� �߻� ������ ���� �ʿ�
    //        Managers.Pool.Push(other.gameObject);
    //    }

    //    // TODO : �̰ɷ� ������ ���� ������ ����ϸ� �ɵ�
    //    // foreach (ContactPoint point in other.contacts)
    //    // {
    //    //     var o = point.otherCollider.gameObject;
    //    //
    //    //     Debug.Log($"{o.gameObject.name}");
    //    // }
    //}
}